module Api exposing (Review, decodeReviews, httpGetString, reviews)

import Helpers exposing (..)
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


{-| 📃 This is the decoder for each Review
-}
reviewDecoder : Decoder Review
reviewDecoder =
    map3 Review
        (field "entry" string)
        (field "author" string)
        (field "author_location" string)


{-| 👀: This decoder needs to be called with:

    decodeString reviewsDecoder JSON

It closely resembles the origial JSON structure

-}
reviewsDecoder : Decoder (List Review)
reviewsDecoder =
    field "reviews"
        (field "review" (list reviewDecoder))


{-| 👀 : This is the reviews decoder
It just needs a string representing a JSON object to parse
-}
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
                |> logError "⛑ Error decoding reviews:"
                |> toNothing


{-| Reviews
-}
reviews : String
reviews =
    "{\"reviews\":{\"review\":[{ \"entry\": \"Hello this is a review\", \"author\": \"Cristian\", \"author_location\": \"Italia\"},{ \"entry\": \"Hello this is another review\",\"author\": \"Marie\", \"author_location\": \"France\"}]}}"
