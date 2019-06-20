module Main exposing (main)

import Api exposing (Review, decodeReviews, httpGetString, reviews)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Decode exposing (decodeString)
import List exposing (head)



-- MODEL


type Msg
    = GotText (Result Http.Error String)


{-| 👀 The model
-}
type Model
    = Loading
    | Error String
    | Complete (Maybe (List Review))


{-| 🏳Flags are at the moment unused
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, httpGetString "http://this.url.wont.work/api/reviews/1243" GotText )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText response ->
            case response of
                -- Tells the view that we have the reviews
                Ok responseBody ->
                    ( Complete (decodeReviews responseBody), Cmd.none )

                -- Tells the view that an error has just been thrown
                Err httpError ->
                    ( Error "Something bad happened, but don't know why", Cmd.none )



-- VIEW


{-| 👨🏻‍💻 → This view shows the error message if any
-}
viewError : String -> Html Msg
viewError str =
    h1 [ class "error" ] [ text str ]


{-| 👀 → This view shows the first review in the list
-}
viewReviews : Maybe (List Review) -> Html Msg
viewReviews maybeReviews =
    let
        reviews =
            case maybeReviews of
                Just theReviews ->
                    theReviews

                Nothing ->
                    []
    in
    div []
        (List.map
            (\{ content, author, authorLocation } ->
                p []
                    [ h2 [] [ text content ]
                    , h1 [] [ text (author ++ ", " ++ authorLocation) ]
                    ]
            )
            reviews
        )


{-| 👀 → This view shows the loading message or a spinner
-}
viewLoader : Html Msg
viewLoader =
    h1 [] [ text "Loading data..." ]


{-| 👀 -> Shows a different view accordingly to the loading state
-}
view : Model -> Html Msg
view model =
    case model of
        Loading ->
            viewLoader

        Complete reviews ->
            viewReviews reviews

        Error message ->
            viewError message



-- SUBSCRIPTIONS


noSubscriptions : Model -> Sub Msg
noSubscriptions model =
    Sub.none



-- MAIN


main =
    Browser.element
        { update = update
        , init = init
        , subscriptions = noSubscriptions
        , view = view
        }
