import router from '@ohos.router';
import { Game } from '../model/game';

interface RouterParams {
  game: Game
}

@Entry
@Component
struct GameDetail {
  @State game: Game = new Game()
  aboutToAppear(): void {
    const params: RouterParams = router.getParams()  as RouterParams
    this.game = params.game
  }

  build() {
    Row() {
      Column() {
        Text(this.game.title)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}