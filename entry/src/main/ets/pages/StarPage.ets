import { GameDetails } from '../model/game';
import hilog from '@ohos.hilog';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct StarPage {
  // @State staredGames: GameDetails[] = []
  @StorageLink('staredGames') staredGames: GameDetails[] = AppStorage.get('staredGames') ?? []

  build() {
    Column() {
      Text('My star list')
        .fontWeight(700)
        .fontSize(26)

      List() {
        ForEach(this.staredGames, (item: GameDetails) => {
          // click game title and game thumbnail should trigger router pushUrl event
          ListItem() {
            Column() {
              Row({ space: 10 }) {
                Text(`${item.title}`)
                  .margin({ left: 15 })
                  .fontSize(20)
                  .fontWeight(600)
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/GameDetail',
                      params: {
                        game_id: item.id
                      }
                    })
                  })

                Text('(Delete)')
                  .fontWeight(500)
                  .fontSize(15)
                  .fontColor('#ff1e3fc6')
                  .layoutWeight(1)
                  .onClick(() => {

                    AlertDialog.show({
                      title: 'Remove game',
                      message: `Are you sure you want to remove ${item.title} from star list?`,
                      primaryButton: {
                        value: 'Confirm',
                        action: () => {
                          this.staredGames = this.staredGames.filter((staredItem) => staredItem.id !== item.id)
                          promptAction.showToast({
                            message: "Game removed!"
                          })
                        }
                      },
                      secondaryButton: {
                        value: 'Cancel',
                        action: () => {}
                      },
                      alignment: DialogAlignment.Center
                    })
                  })
              }
              .justifyContent(FlexAlign.Start)

              Column() {
                Row() {
                  Column({ space: 20 }) {
                    Row() {
                      Column() {
                        Row() {
                          Text('id')
                            .fontColor('#61000000')
                        }
                        .width(100)
                        .margin({ left: 20 })
                      }
                      .width(100)

                      Column() {
                        Text(`${item.id}`)
                      }
                    }

                    Row() {
                      Column() {
                        Row() {
                          Text('Genre')
                            .fontColor('#61000000')
                        }
                        .width(100)
                        .margin({ left: 20 })
                      }
                      .width(100)

                      Column() {
                        Text(`${item.genre}`)
                      }
                    }

                    Row() {
                      Column() {
                        Row() {
                          Text('Platform')
                            .fontColor('#61000000')
                        }
                        .width(100)
                        .margin({ left: 20 })
                      }
                      .width(100)

                      Column() {
                        Text(`${item.platform}`)
                      }
                    }
                  }
                  .width('45%')
                  .alignItems(HorizontalAlign.Start)

                  Column() {
                    Image(`${item.thumbnail}`)
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
                  .width('50%')
                }
                .width('100%')

                Text(`${item.short_description}`)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .borderWidth(1)
          .borderRadius(10)
          .width('90%')
          .margin(10)

        })
      }
      .alignListItem(ListItemAlign.Center)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }
}