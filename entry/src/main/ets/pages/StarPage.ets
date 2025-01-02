import { GameDetails } from '../model/game';
import hilog from '@ohos.hilog';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct StarPage {
  @StorageLink('staredGames') staredGames: GameDetails[] = AppStorage.get('staredGames') ?? []

  build() {
    Column() {
      Text('My star list')
        .fontWeight(700)
        .fontSize(26)
      if (this.staredGames.length == 0) {
        Column({ space: 8 }) {
          Image($r('app.media.icon_no_game'))
            .width('30%')
            .opacity(0.4)
          Text('No game')
            .fontSize(30)
            .fontWeight(500)
            .opacity(0.4)
            .fontFamily('Teko')
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
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
                          action: () => {
                          }
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
                          .alignItems(VerticalAlign.Top)
                        }
                        .width(100)

                        Column() {
                          Text(`${item.genre}`)
                            .width(75)
                        }
                      }
                      .alignItems(VerticalAlign.Top)


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
                        .justifyContent(FlexAlign.Start)

                        Column() {
                          Text(`${item.platform}`)
                            .width(75)
                        }
                      }
                      .alignItems(VerticalAlign.Top)
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

                  Row() {
                    Text(`"${item.short_description}"`)
                  }
                  .width('100%')
                  .padding(10)
                  .borderWidth(1)
                }
                .width('100%')
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
            .borderWidth(1)
            .width('90%')
            .margin(10)
            .shadow({
              radius: 10,
              offsetX: 10,
              offsetY: 10,
              color: '#86000000'
            })

          })
        }
        .alignListItem(ListItemAlign.Center)
        .width('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}