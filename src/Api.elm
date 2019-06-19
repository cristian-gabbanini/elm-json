module Api exposing (Review, decodeReviews, httpGetString, reviews)

import Http exposing (..)
import Json.Decode as Decode exposing (..)


type alias Review =
    { content : String
    , author : String
    , authorLocation : String
    }


httpGetString url message =
    Http.get
        { url = url
        , expect = Http.expectString message
        }


getName : Decoder String
getName =
    field "name" string


getHeight : Decoder Int
getHeight =
    field "height" int


reviewDecoder : Decoder Review
reviewDecoder =
    map3 Review
        (field "entry" string)
        (field "author" string)
        (field "author_location" string)


reviewsDecoder : Decoder (List Review)
reviewsDecoder =
    field "reviews"
        (field "review" (list reviewDecoder))


decodeReviews : String -> Maybe (List Review)
decodeReviews responseFromServer =
    let
        decodedReviews =
            decodeString reviewsDecoder responseFromServer
    in
    case decodedReviews of
        Ok reviewsList ->
            Just reviewsList

        Err message ->
            message
                |> Debug.log "⛑ Error decoding reviews:"
                |> toNothing


{-| 👀 -> This function simply ignores its argument
and returns Nothing
-}
toNothing _ =
    Nothing


{-| Reviews
-}
reviews : String
reviews =
    "{\"reviews\":{\"review\":[{ \"entry\": \"Hello this is a review\", \"author\": \"Cristian\", \"author_location\": \"Italia\"},{ \"entry\": \"Hello this is another review\",\"author\": \"Marie\", \"author_location\": \"France\"}]}}"
