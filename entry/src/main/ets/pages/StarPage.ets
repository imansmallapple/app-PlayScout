import { GameDetails } from '../model/game';
import hilog from '@ohos.hilog';

@Entry
@Component
struct StarPage {
  @State staredGames: GameDetails[] = []

  aboutToAppear(): void {
    this.staredGames = AppStorage.get('staredGames') ?? []

    // Test if stared list can be rendered
    // this.staredGames.forEach((item) => {
    //   hilog.info(23, 'stared games', `${item.title}`)
    // })
  }

  // todo: name, short intro, image, remove button

  build() {
    Column() {
      List() {
        ForEach(this.staredGames, (item: GameDetails) => {
          ListItem() {
            Column() {
              Text(`${item.title}`)
            }
          }
        })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Brown)
  }
}