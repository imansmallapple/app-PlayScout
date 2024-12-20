@Extend(Text)
function titleTextStyle(fontColor: string | ResourceColor) {
  .fontSize(45)
  .fontWeight(FontWeight.Medium)
  .fontColor(fontColor)
}


export { titleTextStyle }