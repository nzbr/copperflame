module Main where

import Debug.Trace
import Data.List (find)
import Data.Text (Text, pack, unpack)
import Text.Pandoc.JSON
import Text.Regex.TDFA ((=~))
import qualified Data.HashSet as HashSet


processText :: Text -> Text
processText t = t


processCaption :: Caption -> Caption
processCaption (Caption Nothing b) = Caption Nothing $ map processBlock b
processCaption (Caption (Just shortCap) b) = Caption (Just $ map processInline shortCap) $ map processBlock b


processTableHead :: TableHead -> TableHead
processTableHead (TableHead a r) = TableHead a $ map processRow r


processRow :: Row -> Row
processRow (Row a c) = Row a $ map processCell c


processCell :: Cell -> Cell
processCell (Cell at al r c xs) = Cell at al r c $ map processBlock xs


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
processInline (Cite cs xs) = Cite cs (map processInline xs) -- technically there's citationPrefix and citationSuffix which contain inlines
processInline (Code a t) = Code a $ processText t
processInline Space = Space
processInline SoftBreak = SoftBreak
processInline LineBreak = LineBreak
processInline (Math t s) = Math t $ processText s
processInline (Link a is (t1, t2)) = Link a (map processInline is) (processText t1, processText t2)
processInline (Image a is (t1, t2)) = Image a (map processInline is) (processText t1, processText t2)
processInline (Note xs) = Note $ map processBlock xs
processInline (RawInline (Format f) t) = RawInline (Format f) $ processText t
processInline (Span a is) = Span a $ map processInline is


processBlock :: Block -> Block
processBlock (Plain xs) = Plain $ map processInline xs
processBlock (Para xs) = Para $ map processInline xs
processBlock (LineBlock xs) = LineBlock $ map (map processInline) xs
processBlock (CodeBlock a t) = CodeBlock a $ processText t
processBlock (RawBlock a t) = RawBlock a $ processText t
processBlock (BlockQuote xs) = BlockQuote $ processBlockList xs
processBlock (OrderedList a xs) = OrderedList a $ map (processBlockList) xs
processBlock (BulletList xs) = BulletList $ map (processBlockList) xs
processBlock (DefinitionList xs) = DefinitionList $ map (\(a, b) -> (map processInline a, map (processBlockList) b)) xs
processBlock (Header i a xs) = Header i a $ map processInline xs
processBlock HorizontalRule = HorizontalRule
processBlock (Table a caption col thead tbody tfoot) = Table a (processCaption caption) col (processTableHead thead) (map processTableBody tbody) (processTableFoot tfoot)
--filterBibTeX (Figure a c xs) = Figure a (processCaption c) (map filterBibTeX xs)
processBlock (Div (id, classes, attrs) blocks) | (pack "minipage") `elem` classes =
               Div (id, (pack "merge") : classes, attrs)
               $ ((RawBlock (Format $ pack "glue{tex}") $ pack $ "\\begin{minipage}{" ++ (unpack width) ++ "\\textwidth}"))
               : (Plain []) -- prepend an empty block to prevent begin and end from being glued together if there's no other content
               : (processBlockList blocks)
               ++ [RawBlock (Format $ pack "glue{tex}") $ pack "\\end{minipage}"]
             where
               width = case (find (\(x,y) -> x == (pack "width")) attrs) of
                  Just (_, w) -> w
                  Nothing -> (pack "0.5")

processBlock (Div attr blocks) | otherwise = Div attr $ processBlockList blocks
processBlock Null = Null


processBlockList :: [Block] -> [Block]
processBlockList blocks = processSequence $ map processBlock blocks
  where
    processSequence ((Div (xi, xc, xa) xb) : (Div (_, yc, ya) yb) : xs)
      | (pack "merge") `elem` xc && (pack "merge") `elem` yc =
        processSequence $ (Div (xi, (merge xc yc), (merge xa ya)) (xb ++ yb)) : xs
    processSequence ((Div (i, c, a) b) : xs)
      | (pack "merge") `elem` c =
         (Div (i, c, a) $ processSequence b) : (processSequence xs) -- process sequence inside freshly merged div
    processSequence ((RawBlock (Format xf) xt) : (RawBlock (Format yf) yt) : xs)
      | xf =~ "glue{.*}" && yf =~ "glue{.*}" && extractFormat xf == extractFormat yf =
        processSequence $ (RawBlock (Format $ xf) $ xt <> yt) : xs
    processSequence ((RawBlock (Format f) t) : xs)
      | f =~ "glue{.*}" =
        processSequence $ (RawBlock (Format $ extractFormat f) t) : xs
    processSequence (x : xs) = x : processSequence xs
    processSequence [] = []

    merge xs ys = HashSet.toList $ HashSet.fromList xs `HashSet.union` HashSet.fromList ys
    extractFormat f = pack $ firstGroup ((unpack f) =~ "glue{(.*)}" :: (String, String, String, [String]))
    firstGroup (_, _, _, [g]) = g

processPandoc :: Pandoc -> Pandoc
processPandoc (Pandoc meta blocks) = Pandoc meta $ processBlockList blocks

main :: IO ()
main = toJSONFilter processPandoc
