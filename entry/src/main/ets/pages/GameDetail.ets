import router from '@ohos.router';
import { GameDataSource } from '../data/DataSource';
import { Game, GameDetails, ScreenShot } from '../model/game';

interface RouterParams {
  game_id: number
}

@Entry
@Component
struct GameDetail {
  @State httpCode: number = 0
  private game_id: number = 0
  @State gameDetail: GameDetails = new GameDetails()
  @State screenshots: ScreenShot[] = []
  scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    const params: RouterParams = router.getParams() as RouterParams
    this.game_id = params.game_id

    const source = new GameDataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        this.gameDetail = await source.GetGamesDetail(this.game_id)
        this.screenshots = this.gameDetail.screenshots
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  build() {
    Scroll() {
      List({ scroller: this.scroller }) {
        ForEach(this.screenshots, (item: ScreenShot, index: number) => {
          ListItem() {
            Column() {
              Image(`${item.image}`)
                .objectFit(ImageFit.Contain)
                .margin({ left: 5, right: 5, bottom: 5 })
                .borderRadius(5)
            }
            .width('100%')
          }
        })
      }
      .alignSelf(ItemAlign.Start)
    }
    .width('100%')
    .height('100%')
  }
}