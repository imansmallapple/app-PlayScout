import { Game } from '../model/game';
import router from '@ohos.router';
import { GameDataSource } from '../data/DataSource';
import { HttpErrorComponent, LoadComponent } from '../Component/components';

interface RouterParams {
  tag: string
}

@Entry
@Component
struct SortByTagPage {
  @State isLoading: boolean = false
  @State isHttpError: boolean = false
  @State tag: string = ''
  @State httpCode: number = 0
  @State sortedByTagGameList: Game[] = []
  private scroller: Scroller = new Scroller()

  aboutToAppear(): void {
    this.isLoading = true;
    const params: RouterParams = router.getParams() as RouterParams;
    this.tag = params.tag

    const source = new GameDataSource();

    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code;
      if (code === 200) {
        this.sortedByTagGameList = await source.SortGamesByTag(this.tag)
        this.isLoading = false;
      } else {
        this.isHttpError = true;
        this.isLoading = false;
        console.error('Failed to fetch data: HTTP Code', code);
      }
    });
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

  build() {
    Column() {
      if (this.isHttpError) {
        Column() {
          HttpErrorComponent()
        }
        .width('100%')
        .height('100%')
      }

      if (this.isLoading) {
        Column() {
          LoadComponent()
        }
        .width('100%')
        .height('100%')
      } else {
        Text(`${this.tag}`)
          .fontWeight(700)
          .fontSize(26)

        // Game list
        List({ scroller: this.scroller }) {
          ForEach(this.sortedByTagGameList, (item: Game) => {
            ListItem() {
              Row({ space: 20 }) {
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
    }
    .width('100%')
    .height('100%')
  }
}