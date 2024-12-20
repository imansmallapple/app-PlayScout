import { GameDataSource, MyDataSource } from '../data/DataSource'
import { Game } from '../model/game'

@Entry
@Component
struct Index {
  @State httpCode: number = 0
  @State dataSet: MyDataSource = new MyDataSource()
  @State gameList: Game[] = []

  aboutToAppear(): void {
    const source = new GameDataSource()

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code

      if (code === 200) {
        const list = await source.GetGameList()
        this.gameList = list;

        // 初始化数据和图片 URL
        this.gameList.forEach((item, index) => {
          this.dataSet.pushData(item);
          console.info(`Game info:${item.title}`)
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
      right:10,
      bottom:5
    })
    .backdropBlur(20)
  }

  build() {
    Stack({ alignContent: Alignment.BottomEnd }) {
      Column() {
        Row(){
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

        // Slider Component
        // todo: Add Slider component

        // Category Bar
        // todo: Add Catefory bar

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
      .margin({right: 20, bottom: 20})

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