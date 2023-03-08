module Main where

import Data.Text (Text, pack, unpack)
import Text.Pandoc.JSON


processText :: Text -> Text
processText t = t


processCaption :: Caption -> Caption
processCaption (Caption Nothing b) = Caption Nothing $ map filterBibTeX b
processCaption (Caption (Just shortCap) b) = Caption (Just $ map processInline shortCap) $ map filterBibTeX b


processTableHead :: TableHead -> TableHead
processTableHead (TableHead a r) = TableHead a $ map processRow r


processRow :: Row -> Row
processRow (Row a c) = Row a $ map processCell c


processCell :: Cell -> Cell
processCell (Cell at al r c xs) = Cell at al r c $ map filterBibTeX xs


processTableBody :: TableBody -> TableBody
processTableBody (TableBody a h xs ys) = TableBody a h (map processRow xs) (map processRow ys)


processTableFoot :: TableFoot -> TableFoot
processTableFoot (TableFoot a xs) = TableFoot a $ map processRow xs


processInline :: Inline -> Inline
processInline (Str s) = Str $ processText s
processInline (Emph is) = Emph $ map processInline is
processInline (Underline is) = Underline $ map processInline is
processInline (Strong is) = Strong $ map processInline is
processInline (Strikeout is) = Strikeout $ map processInline is
processInline (Superscript is) = Superscript $ map processInline is
processInline (Subscript is) = Subscript $ map processInline is
processInline (SmallCaps is) = SmallCaps $ map processInline is
processInline (Quoted q is) = Quoted q $ map processInline is
processInline (Cite cs _) = processInline $ Span nullAttr $ map (processInline . citeToTex) cs
  where
    citeToTex (Citation {citationId = cId, citationPrefix = p, citationSuffix = s}) =
      Span nullAttr $ map processInline $ p ++ [RawInline (Format $ pack "tex") $ pack $ "\\cite{" ++ (unpack cId) ++ "}" ] ++ s
processInline (Code a t) = Code a $ processText t
processInline Space = Space
processInline SoftBreak = SoftBreak
processInline LineBreak = LineBreak
processInline (Math t s) = Math t $ processText s
processInline (Link a is (t1, t2)) = Link a (map processInline is) (processText t1, processText t2)
processInline (Image a is (t1, t2)) = Image a (map processInline is) (processText t1, processText t2)
processInline (Note xs) = Note $ map filterBibTeX xs
processInline (RawInline (Format f) t) = RawInline (Format f) $ processText t
processInline (Span a is) = Span a $ map processInline is


filterBibTeX :: Block -> Block
filterBibTeX (Plain xs) = Plain $ map processInline xs
filterBibTeX (Para xs) = Para $ map processInline xs
filterBibTeX (LineBlock xs) = LineBlock $ map (map processInline) xs
filterBibTeX (CodeBlock a t) = CodeBlock a $ processText t
filterBibTeX (RawBlock a t) = RawBlock a $ processText t
filterBibTeX (BlockQuote xs) = BlockQuote $ map filterBibTeX xs
filterBibTeX (OrderedList a xs) = OrderedList a $ map (map filterBibTeX) xs
filterBibTeX (BulletList xs) = BulletList $ map (map filterBibTeX) xs
filterBibTeX (DefinitionList xs) = DefinitionList $ map (\(a, b) -> (map processInline a, map (map filterBibTeX) b)) xs
filterBibTeX (Header i a xs) = Header i a $ map processInline xs
filterBibTeX HorizontalRule = HorizontalRule
filterBibTeX (Table a caption col thead tbody tfoot) = Table a (processCaption caption) col (processTableHead thead) (map processTableBody tbody) (processTableFoot tfoot)
--filterBibTeX (Figure a c xs) = Figure a (processCaption c) (map filterBibTeX xs)
filterBibTeX (Div a xs) = Div a $ map filterBibTeX xs
filterBibTeX Null = Null


main :: IO ()
main = toJSONFilter filterBibTeX
