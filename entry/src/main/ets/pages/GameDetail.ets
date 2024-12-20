import router from '@ohos.router';
import { GameDataSource } from '../data/DataSource';
import { Game, GameDetails } from '../model/game';

interface RouterParams {
  game_id: number
}

@Entry
@Component
struct GameDetail {
  @State httpCode: number = 0
  private game_id: number = 0
  @State gameDetail: GameDetails = new GameDetails()

  aboutToAppear(): void {
    const params: RouterParams = router.getParams()  as RouterParams
    this.game_id = params.game_id

    const source = new GameDataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
      this.gameDetail = await source.GetGamesDetail(this.game_id)
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
      }
    })
  }

  build() {
    Row() {
      Column() {
        Text(`Title:${this.gameDetail.title}`)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}