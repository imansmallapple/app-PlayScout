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

  build() {
    Row(){
      Text("PLAY SCOUT")
      Text(`Http code: ${this.httpCode}`)
    }
  }
}