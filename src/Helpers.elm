module Helpers exposing (logError, toNothing)

{-| 👀 -> This function simply ignores its argument
and returns Nothing
-}


toNothing _ =
    Nothing


logError : String -> a -> a
logError tag target =
    Debug.log tag target
