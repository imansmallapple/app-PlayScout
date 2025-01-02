import { GameDataSource } from '../data/DataSource'
import { Game, GameDetails } from '../model/game'
import router from '@ohos.router'
import { tagList, platformList } from '../data/list'
import { HttpErrorComponent, LoadComponent } from '../Component/components'
import hilog from '@ohos.hilog'
import font from '@ohos.font'
import { registerAllFonts } from '../font/registerFonts'
import promptAction from '@ohos.promptAction'

PersistentStorage.persistProp<GameDetails[]>('staredGames', [])

@Entry
@Component
struct Index {
  @State httpCode: number = 0
  @State recent_games: Game[] = []
  @State recent_all_games: Game[] = []
  @State gameList: Game[] = []
  // Recent released 5 games
  @State recent_games_thumbnails: string[] = []
  private swiperController: SwiperController = new SwiperController()
  private swiperMargin: number = 10
  @State isSortByRecentSelect: boolean = false
  @State isSortByCategory: boolean = false
  @State isSortByPlatform: boolean = false
  @State isListLoading: boolean = false
  @State isGlobalLoading: boolean = false
  private scroller: Scroller = new Scroller()
  private tagList: string[] = tagList
  private platformList: string[] = platformList
  @State select: number = 0
  @State currentTag: string = ''
  @State currentPlatform: string = ''
  @State tagGameList: Game[] = []
  @State platformGameList: Game[] = []
  @State isHttpError: boolean = false

  aboutToAppear(): void {
    registerAllFonts()
    this.isGlobalLoading = true;
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code

      if (code === 200) {
        this.gameList = await source.GetGameList()

        const recent_games = await source.GetRecentGames()
        this.recent_games = recent_games
        await Promise.all(recent_games)

        this.recent_games.forEach((item, index) => {
          this.recent_games_thumbnails[index] = item.thumbnail
        })

        this.isGlobalLoading = false;
      } else {
        this.isHttpError = true;
        this.isGlobalLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  sortByTag(tag: string): void {
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        this.isListLoading = true;
        const tag_games = await source.SortGamesByTag(tag)
        this.tagGameList = tag_games
        this.isListLoading = false;
      } else {
        this.isListLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  sortByPlatform(platform: string): void {
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        this.isListLoading = true;
        const platform_games = await source.SortGamesByPlatform(platform)
        this.platformGameList = platform_games
        this.isListLoading = false;
      } else {
        this.isListLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  sortByReleaseDate(): void {
    // this.dataSet.clear()
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code

      if (code === 200) {
        this.isListLoading = true;
        this.recent_all_games = await source.GetAllRecentGames()
        this.gameList = this.recent_all_games
        this.isListLoading = false;
      } else {
        this.isListLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  tagConverter(tag: string): string {
    if (tag == 'Action RPG' || tag == 'ARPG') {
      return 'action-rpg'
    } else if (tag == 'MMOARPG') {
      return 'MMORPG'
    } else if (tag == 'Card Game') {
      return 'card'
    } else if (tag == 'Battle Royale') {
      return 'battle-royale'
    }
    return tag
  }

  private smoothScrollToTop() {
    const scrollDuration = 1000
    const frameRate = 60
    const interval = 1000 / frameRate
    const totalFrames = scrollDuration / interval

    let currentFrame = 0;
    const startY = this.scroller.currentOffset().yOffset
    const distance = -startY

    const scrollStep = () => {
      currentFrame++;
      const progress = Math.min(currentFrame / totalFrames, 1)
      const easeOutQuad = (t: number) => t * (2 - t)
      const easedProgress = easeOutQuad(progress)

      this.scroller.scrollTo({
        xOffset: 0,
        yOffset: startY + distance * easedProgress,
        animation: false,
      });

      if (currentFrame < totalFrames) {
        setTimeout(scrollStep, interval)
      }
    };

    scrollStep()
  }

  @Builder
  floatIconBuilder(icon: Resource, callback?: () => void) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
        .zIndex(1)
        .objectFit(ImageFit.Contain)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#33000000')
    .borderRadius(30)
    .width(45)
    .height(45)
    .margin({
      right: 10,
      bottom: 5
    })
    .backdropBlur(20)
    .onClick(callback)
  }

  @Builder
  dividerBuilder(width: number) {
    Divider()
      .strokeWidth(2)
      .width(width)
      .color('#ff1e3fc6')
  }

  build() {
    Stack() {
      if (this.isHttpError) {
        Column() {
          HttpErrorComponent({
            text: 'Seems you don\'t have Internet'
          })
        }
        .width('100%')
        .height('100%')
      } else {
        if (this.isGlobalLoading) {
          LoadComponent()
        } else {
          Column() {
            Row() {
              // Title Bar

              Row() {
                Text('PLAY')
                  .titleTextStyle('#ff000000')

                Text('ES')
                  .titleTextStyle('#A65EEA')

                Text('COUT')
                  .titleTextStyle('#ff000000')

              }
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height('10%')

            Row() {
              Text('What\'s new')
                .fontWeight(700)
                .fontSize(28)
                .margin({ left: 10 })
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)

            // Swiper Component
            Swiper(this.swiperController) {
              Image(this.recent_games_thumbnails[0])
                .swiperImageStyle(this.recent_games[0])
              Image(this.recent_games_thumbnails[1])
                .swiperImageStyle(this.recent_games[1])
              Image(this.recent_games_thumbnails[2])
                .swiperImageStyle(this.recent_games[2])
              Image(this.recent_games_thumbnails[3])
                .swiperImageStyle(this.recent_games[3])
              Image(this.recent_games_thumbnails[4])
                .swiperImageStyle(this.recent_games[4])
            }
            .cachedCount(3)
            .index(0)
            .autoPlay(true)
            .interval(5000)
            .indicator(true)
            .loop(true)
            .duration(1000)
            .itemSpace(20)
            .curve(Curve.Linear)
            .onChange((index: number) => {
              console.info(index.toString())
              // console.info(getContext(this).resourceManager.getStringSync($r('app.string.search')).toString())
            })
            .margin({ top: 10 })
            .prevMargin(this.swiperMargin)
            .nextMargin(this.swiperMargin)

            // Category Bar
            Column() {
              Row() {
                Column() {
                  Text(this.currentTag == '' ? 'Categories' : this.currentTag)
                    .fontColor(this.isSortByCategory ? '#ff1e3fc6' : '#ff000000')
                    .textStyle()
                    .onClick(() => {
                      TextPickerDialog.show({
                        range: this.tagList,
                        selected: this.select,
                        onAccept: (item: TextPickerResult) => {
                          this.select = item.index as number
                          this.currentTag = item.value as string
                          this.isSortByRecentSelect = false
                          this.isSortByPlatform = false
                          this.isSortByCategory = true

                          this.sortByTag(this.currentTag)
                        },
                        onCancel: () => {
                        },
                        alignment: DialogAlignment.Center
                      })
                    })
                  if (this.isSortByCategory) {
                    this.dividerBuilder(100)
                  }
                }

                Column() {
                  Text('Recent Games')
                    .textStyle()
                    .onClick(() => {
                      this.isSortByCategory = false
                      this.isSortByPlatform = false
                      this.isSortByRecentSelect = true
                      this.sortByReleaseDate()
                    })
                    .fontColor(this.isSortByRecentSelect ? '#ff1e3fc6' : '#ff000000')
                  if (this.isSortByRecentSelect) {
                    this.dividerBuilder(130)
                  }
                }

                Column() {
                  Text(this.currentPlatform == '' ? 'Platform' : this.currentPlatform)
                    .textStyle()
                    .onClick(() => {
                      TextPickerDialog.show({
                        range: this.platformList,
                        selected: this.select,
                        onAccept: (item: TextPickerResult) => {
                          this.select = item.index as number
                          this.currentPlatform = item.value as string
                          this.isSortByCategory = false
                          this.isSortByRecentSelect = false
                          this.isSortByPlatform = true
                          this.sortByPlatform(this.currentPlatform)
                        },
                        onCancel: () => {
                        },
                        alignment: DialogAlignment.Center,
                        canLoop: false
                      })
                    })
                    .fontColor(this.isSortByPlatform ? '#ff1e3fc6' : '#ff000000')
                  if (this.isSortByPlatform) {
                    this.dividerBuilder(100)
                  }
                }
              }
              .width('100%')
              .height(40)
              .justifyContent(FlexAlign.SpaceEvenly)
              .alignItems(VerticalAlign.Center)
            }
            .width('100%')

            if (this.isListLoading) {
              Column() {
                LoadComponent() // 显示加载组件
              }
              .width('100%')
              .layoutWeight(1)
              .justifyContent(FlexAlign.Center)
            } else {
              // Game list
              List({ scroller: this.scroller }) {
                // For unknown reason, use LazyForEach with dataSet always easily crash, use ForEach instead
                ForEach(this.isSortByCategory ? this.tagGameList : (this.isSortByPlatform ? this.platformGameList : this.gameList), (item: Game) => {
                  ListItem() {
                    Row({ space: 20 }) {
                      // Add if statement to avoid program crash
                      if (item.thumbnail) {
                        Image(`${item.thumbnail}`)
                          .height('100%')
                          .onClick(() => {
                            router.pushUrl({
                              url: 'pages/GameDetail',
                              params: {
                                game_id: item.id
                              }
                            })
                          })
                      }
                      Column({ space: 3 }) {
                        Text(`${item.title}`)
                          .fontWeight(700)
                          .fontSize(20)
                          .onClick(() => {
                            router.pushUrl({
                              url: 'pages/GameDetail',
                              params: {
                                game_id: item.id
                              }
                            })
                          })
                        Row() {
                          Column() {
                            Text(`${item.genre}`)
                              .fontColor('#ffffffff')
                          }
                          .padding(5)
                          .borderWidth(1)
                          .backgroundColor('#3b000000')
                          .onClick(() => {
                            router.pushUrl({
                              url: 'pages/SortByTagPage',
                              params: {
                                tag: this.tagConverter(item.genre)
                              }
                            })
                            hilog.info(23, 'tagInfo', `${this.tagConverter(item.genre)}`)
                          })

                          Column({ space: 5 }) {
                            Image(item.platform === "PC (Windows)" ? $r('app.media.icon_window') : $r('app.media.icon_browser'))
                              .width(20)
                            Text(`${item.release_date}`)
                              .fontColor('#56000000')
                          }
                          .layoutWeight(1)
                          .alignItems(HorizontalAlign.End)
                          .onClick(() => {
                            router.pushUrl({
                              url: 'pages/SortByPlatformPage',
                              params: {
                                platform: item.platform
                              }
                            })
                          })
                        }
                        .layoutWeight(1)
                        .height('100%')
                        .justifyContent(FlexAlign.End)
                        .alignItems(VerticalAlign.Bottom)
                      }
                      .layoutWeight(1)
                      .height('100%')
                      .justifyContent(FlexAlign.Start)
                      .alignItems(HorizontalAlign.Start)
                    }
                    .width('100%')
                    .height(100)
                  }
                  .margin(5)
                  .padding(5)
                  .borderWidth(1)
                })
              }
              .width('100%')
            }

            // About Author
            // todo: Add author information
          }
          .width('100%')
          .height('100%')

          Column() {
            this.floatIconBuilder($r('app.media.icon_top'), () => {
              // this.scroller.scrollEdge(Edge.Top)
              this.smoothScrollToTop()
            })
            this.floatIconBuilder($r('app.media.icon_badge'), () => {
              router.pushUrl({
                url: 'pages/StarPage'
              })
            })
            this.floatIconBuilder($r('app.media.icon_search'))
          }
          .margin({ right: 20, bottom: 20 })
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .align(this.isGlobalLoading ? Alignment.Center : Alignment.BottomEnd)
  }
}

@Extend(Text)
function titleTextStyle(fontColor: string | ResourceColor) {
  .fontSize(40)
  .fontWeight(FontWeight.Bolder)
  .fontColor(fontColor)
  .fontFamily('ExtraBold')
}

@Extend(Image)
function swiperImageStyle(game: Game) {
  .width('100%')
  .height(180)
  .borderRadius(15)

  // Trigger click event which will navigates to game detail page
  .onClick(() => {
    router.pushUrl({
      url: 'pages/GameDetail',
      params: {
        game_id: game.id
      }
    })
  })
}

@Extend(Text)
function textStyle() {
  .fontSize(20)
  .fontWeight(600)
  .fontFamily('Poppins')
}