import Platform from '../enum/platform'
import Tag from '../enum/tag'

class Game {
  id: number = 0
  title: string = ''
  thumbnail: string = ''
  short_description: string = ''
  game_url: string = ''
  genre: Tag = Tag.mmorpg
  platform: Platform = Platform.pc
  publisher: string = ''
  developer: string = ''
  release_date: string = ''
  freetogame_profile_url: string = ''
}

interface Min_System_Requirements {
  os: string
  processor: string
  memory: string
  graphics: string
  storage: string
}

interface ScreenShot {
  id: number
  image: string
}

interface GameDetail {
  game: Game
  min_requirements: Min_System_Requirements
  screenshots: ScreenShot[]
}

export { Game, GameDetail, ScreenShot, Min_System_Requirements }