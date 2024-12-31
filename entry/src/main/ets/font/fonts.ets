export interface Font {
  familyName: string;
  familySrc: string;
}

interface Fonts {
  semi_bold: Font;
  bold: Font;
  medium: Font;
  light: Font;
  regular: Font;
  extraBold: Font;
  italic: Font;
  teko: Font;
  poppins: Font;
}

export const fonts: Fonts = {
  semi_bold: {
    familyName: 'SemiBold',
    familySrc: '/font/PlusJakartaSans-semiBold.ttf',
  },
  bold: {
    familyName: 'Bold',
    familySrc: '/font/PlusJakartaSans-Bold.ttf',
  },
  medium: {
    familyName: 'Medium',
    familySrc: '/font/PlusJakartaSans-Medium.ttf',
  },
  light: {
    familyName: 'Light',
    familySrc: '/font/PlusJakartaSans-Light.ttf',
  },
  regular: {
    familyName: 'Regular',
    familySrc: '/font/PlusJakartaSans-Regular.ttf',
  },
  extraBold: {
    familyName: 'ExtraBold',
    familySrc: '/font/PlusJakartaSans-ExtraBold.ttf',
  },
  italic: {
    familyName: 'Italic',
    familySrc: '/font/PlusJakartaSans-Italic.ttf',
  },
  teko: {
    familyName: 'Teko',
    familySrc: '/font/Teko-VariableFont_wght.ttf',
  },
  poppins: {
    familyName: 'Poppins',
    familySrc: '/font/Poppins-Medium.ttf',
  }
}
