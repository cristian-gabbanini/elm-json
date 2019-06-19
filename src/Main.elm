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
init unusedFlags =
    ( Loading, httpGetString "https://swapi.co/api/people/11/" GotText )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotText response ->
            case response of
                -- Tells the view that we have the reviews
                Ok reviewsInAString ->
                    ( Complete (decodeReviews reviews), Cmd.none )

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

        { content, author, authorLocation } =
            case List.head reviews of
                Just review ->
                    review

                Nothing ->
                    { content = "..."
                    , author = "..."
                    , authorLocation = "..."
                    }
    in
    pre []
        [ div [] [ text content ]
        , div [] [ text author ]
        , div [] [ text authorLocation ]
        ]


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

        Complete reviewsInAString ->
            viewReviews reviewsInAString

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
