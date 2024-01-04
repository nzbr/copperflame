import { palette } from "./palette";

export type ColorScheme = typeof palette & {
  foreground: string;
  background: string;
  foregroundSecondary: string;
  backgroundSecondary: string;
  error: string;
  shadow: string;
  highlight: string;
}

export const darkColors: ColorScheme = {
  ...palette,
  foreground: palette.base06,
  background: palette.base00,
  foregroundSecondary: palette.base04,
  backgroundSecondary: palette.base01,
  error: palette.base08,
  shadow: "#000000",
  highlight: palette.baseF6,
}

export const darkProColors: ColorScheme = {
  ...darkColors,
  highlight: palette.baseF4,
}

export const lightColors: ColorScheme = {
  ...palette,
  foreground: palette.base01,
  background: palette.base07,
  foregroundSecondary: palette.base03,
  backgroundSecondary: palette.base06,
  error: palette.base08,
  shadow: palette.base03,
  highlight: palette.baseF5,
}

export const lightProColors: ColorScheme = {
  ...lightColors,
  highlight: palette.baseF4,
}
