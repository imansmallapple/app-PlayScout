# app-PlayScout
## Introduction
Explore and download free games effortlessly. Your gateway to endless gaming adventures!
## Screenshots
![Alt text](images/image_1.PNG)  
![Alt text](images/image_2.PNG)  
![Alt text](images/image_3.PNG)  
![Alt text](images/image_4.PNG)  
![Alt text](images/image_5.PNG)  
![Alt text](images/image_6.PNG)  
![Alt text](images/image_7.PNG)  
![Alt text](images/image_8.PNG)  

# Table of content
Here listed a series of problems/noticable thing during the development.

[Font Grabled](#font-grabled)  
[Image List Detail](#image-list-detail)  
[Game Star list](#game-star-list)  
[Index game list crash](#index-game-list-crash)  
#### Font Grabled
The font grabled in the previewer, but later when we use real device to test it go back to normal.


#### Image List Detail
##### Requirements
The aim is to design a scrollable image list, there are 2 parts: top image(Show image screenshot detail with a big size), small list list preview(The direction is horizontal with small size).
When we click the small list image item, the top big image should be changed, and the screenshots also change automatically with 5s delay.

##### Implementation 1: Implement small list and click trigger top image rerendering
The idea is to define a common state variable `@State selectedIndex: number = 0` and use it in both small image list and the top detail image.

```typescript
    // Image screenshot detail
    Row() {
    if (this.screenshots[0] !== undefined) {
        Image(`${this.screenshots[this.selectedIndex].image}`)
    }
 }
```

```typescript
    // Small image list
    List({ scroller: this.scroller, initialIndex: this.selectedIndex }) {
        ForEach(this.screenshots, (item: ScreenShot, index: number) => {
        ListItem() {
            Column() {
            if (this.selectedIndex == index) {
                Image(`${item.image}`)
                .objectFit(ImageFit.Contain)
                .borderWidth(2)
                .borderColor('#6dd91d1d')
            } else {
                Image(`${item.image}`)
                .objectFit(ImageFit.Contain)
                .onClick(() => {
                    this.selectedIndex = index
                })
            }
            }
        }
        .width('31%')
        .margin(5)
        })
    }
    .listDirection(Axis.Horizontal)
    .cachedCount(3) // render 3 image in cache
```


##### Implementation 2: Implement index auto-change
THe idea is to define a timer, and when the index changed to the last page, use module sign `%` to trace back to the first page.
```typescript
aboutToAppear(): void {
    this.startAutoSwitch();
}
```
```typescript
  // Timer：Change to next image with 5s delay
  private startAutoSwitch() {
    if (this.screenshots.length > 0) {
      this.intervalId = setInterval(() => {
        this.selectedIndex = (this.selectedIndex + 1) % this.screenshots.length;
      }, 5000);
    }
  }
```
```typescript
  // Clear timer
  onDestroy(): void {
    if (this.intervalId !== null) {
      clearInterval(this.intervalId);
    }
  }
```

#### Game Star List
To make a star list, the idea is similar with `Time Around World` app, we need to make a global stared list, and label `Stared` for each stared game.

First we define the star list as following:
```typescript
PersistentStorage.persistProp<GameDetails[]>('staredGames', [])
```

To use in the page, and locally create a `@State` decorated variable `isStared`
```typescript
  @StorageLink('staredGames') staredGames: GameDetails[] = []
  @State isStared: boolean = false
```

In `aboutToAppear` phase, we call `this.staredGames.some` method to check if current game is stared or not
```typescript
  aboutToAppear(): void {
    const params: RouterParams = router.getParams() as RouterParams;
    this.game_id = params.game_id;

    const source = new GameDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;
      if (code === 200) {
        this.gameDetail = await source.GetGamesDetail(this.game_id);
        this.screenshots = this.gameDetail.screenshots;
        this.min_system_requirements = this.gameDetail.minimum_system_requirements;

        // 检查是否已收藏
        this.isStared = this.staredGames.some((item) => item.id === this.gameDetail.id);
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
  }
```

To unstar current game use `filter` method in list
```typescript
Image(this.isStared === true ? $r('app.media.icon_stared') : $r('app.media.icon_not_stared'))
  .width(20)
  .objectFit(ImageFit.Auto)
  .onClick(() => {
    // Each game can only be stared once
    this.isStared = !this.isStared
    if (this.isStared) {
      this.staredGames.push(this.gameDetail)
    } else {
      // Remove game from stared list using filter
      this.staredGames = this.staredGames.filter((item) => item.id !== this.gameDetail.id);
    }
    // Test stared game list data
    // this.staredGames.forEach((item) => {
    //   hilog.info(23, 'stared games', `${item.title}`)
    // })
  })
```

#### Index game list crash
Program crash when we rapidly slide the game list, hilog says it's image render problem
```typescript
  Column() {
    // Add if statement to avoid program crash
    if (item.thumbnail) {
      Image(`${item.thumbnail || ''}`)
        .width('100%')
        .margin(10)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/GameDetail',
            params: {
              game_id: item.id
            }
          })
        })
    }
  }
  .width('50%')
```

##### Solution for this case
Use `ForEach` instead of `LazyForEach` to render game list

