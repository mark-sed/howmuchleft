import Data.Time.Clock
import Data.Time.Calendar
import Data.Time.Format

end_date :: String
end_date = "16-12-2021"

start_date :: String
start_date = "20-09-2021"

date :: IO(Integer, Int, Int)
date = getCurrentTime >>= return . toGregorian . utctDay 

parse_day :: String -> Day
parse_day s = readTime defaultTimeLocale "%d-%m-%Y" s

get_days_left :: UTCTime -> Integer
get_days_left today = diffDays (parse_day end_date) (utctDay today)

format_msg :: UTCTime -> String
format_msg today = "There are " ++ (show (get_days_left today)) ++ " days (" 
                   ++ (show $ ceiling( (fromIntegral $ get_days_left today) / 7.0 )) 
                   ++ " weeks) left in this semester.\n"

semester_length :: Integer
semester_length = diffDays (parse_day end_date) (parse_day start_date)

get_percentage :: UTCTime -> Double
get_percentage today = (fromIntegral $ (diffDays (utctDay today) (parse_day start_date))) 
                       / (fromIntegral semester_length)

bar_max_len :: UTCTime -> Int
bar_max_len today = (length $ format_msg today)-6-(length $ show $ round $ 100 * (get_percentage today))

get_bar_fill :: UTCTime -> Int
get_bar_fill today = round $ (fromIntegral $ bar_max_len today) * (get_percentage today)

format_bar :: UTCTime -> String
format_bar today = "(" ++ (take (get_bar_fill today) $ repeat '=' ) 
                   ++ (take ((bar_max_len today) - (get_bar_fill today)) $ repeat ' ') ++ ") "
                   ++ (show $ round $ 100 * (get_percentage today)) ++ " %\n"

main :: IO()
main = do
    today <- getCurrentTime
    putStr $ format_msg today
    putStr $ format_bar today
