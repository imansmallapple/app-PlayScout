import { GameDataSource, MyDataSource } from '../data/DataSource'
import { Game } from '../model/game'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  @State httpCode: number = 0
  @State dataSet: MyDataSource = new MyDataSource()
  @State gameList: Game[] = []
  // Recent released 5 games
  private recent_games: Game[] = []
  @State recent_games_thumbnails: string[] = []
  private swiperController: SwiperController = new SwiperController()
  private swiperMargin: number = 10
  @State isSelect: boolean = false

  aboutToAppear(): void {
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code

      if (code === 200) {
        this.gameList = await source.GetGameList()
        const recent_games = await source.GetRecentGames()
        this.recent_games = recent_games

        await Promise.all(recent_games); // 等待所有异步任务完成

        // 初始化数据和图片 URL
        this.recent_games.forEach((item, index) => {
          this.dataSet.pushData(item);
          this.recent_games_thumbnails[index] = item.thumbnail
        });
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })

  }

  @Builder
  floatIconBuilder(icon: Resource) {
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
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
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
        // todo: Add Catefory bar, sort by alphabet tag and sort by release date tag
        Column() {
          Row(){
            Text('Categories')
              .textStyle()
            Text('Recent Games')
              .textStyle()
            Text('Category')
              .textStyle()
          }
          .width('100%')
          .height(40)
          .justifyContent(FlexAlign.SpaceEvenly)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')

        // About Author
        // todo: Add author information
      }
      .width('100%')
      .height('100%')

      Column() {
        this.floatIconBuilder($r('app.media.icon_home'))
        this.floatIconBuilder($r('app.media.icon_badge'))
        this.floatIconBuilder($r('app.media.icon_search'))
      }
      .margin({ right: 20, bottom: 20 })

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}

@Extend(Text)
function titleTextStyle(fontColor: string | ResourceColor) {
  .fontSize(28)
  .fontWeight(FontWeight.Bold)
  .fontColor(fontColor)
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
function textStyle(){
  .fontSize(20)
  .fontWeight(600)
}