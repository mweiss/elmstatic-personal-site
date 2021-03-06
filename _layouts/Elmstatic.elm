module Elmstatic exposing
    ( Content
    , Format(..)
    , Layout
    , Page
    , Post
    , PostList
    , decodePage
    , decodePost
    , decodePostList
    , htmlTemplate
    , inlineScript
    , layout
    , script
    , stylesheet
    )

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Json


type Format
    = Markdown
    | ElmMarkup


type alias Post =
    { content : String
    , date : String
    , format : Format
    , link : String
    , section : String
    , siteTitle : String
    , tags : List String
    , title : String
    }


type alias Page =
    { content : String
    , format : Format
    , siteTitle : String
    , title : String
    }


type alias PostList =
    { posts : List Post
    , section : String
    , siteTitle : String
    , title : String
    }


type alias Content a =
    { a | siteTitle : String, title : String }


type alias Layout =
    Program Json.Value Json.Value Never


{-| For backward compatibility, look for the content either in `markdown` or `content` fields
-}
decodeContent : Json.Decoder String
decodeContent =
    Json.oneOf [ Json.field "markdown" Json.string, Json.field "content" Json.string ]


decodeFormat : Json.Decoder Format
decodeFormat =
    Json.oneOf
        [ Json.map
            (\format ->
                if format == "emu" then
                    ElmMarkup

                else
                    Markdown
            )
          <|
            Json.field "format" Json.string
        , Json.succeed Markdown
        ]


decodePage : Json.Decoder Page
decodePage =
    Json.map4 Page
        decodeContent
        decodeFormat
        (Json.field "siteTitle" Json.string)
        (Json.field "title" Json.string)


decodePost : Json.Decoder Post
decodePost =
    Json.map8 Post
        decodeContent
        (Json.field "date" Json.string)
        decodeFormat
        (Json.field "link" Json.string)
        (Json.field "section" Json.string)
        (Json.field "siteTitle" Json.string)
        (Json.field "tags" <| Json.list Json.string)
        (Json.field "title" Json.string)


decodePostList : Json.Decoder PostList
decodePostList =
    Json.map4 PostList
        (Json.field "posts" <| Json.list decodePost)
        (Json.field "section" Json.string)
        (Json.field "siteTitle" Json.string)
        (Json.field "title" Json.string)


script : String -> Html Never
script src =
    node "citatsmle-script" [ attribute "src" src ] []


inlineScript : String -> Html Never
inlineScript js =
    node "citatsmle-script" [] [ text js ]


stylesheet : String -> Html Never
stylesheet href =
    node "link" [ attribute "href" href, attribute "rel" "stylesheet", attribute "type" "text/css" ] []


htmlTemplate : String -> List (Html Never) -> Html Never
htmlTemplate title contentNodes =
    node "html"
        [ attribute "lang" "en" ]
        [ node "head"
            []
            [ node "title" [] [ text title ]
            , node "meta" [ attribute "charset" "utf-8" ] []
            , node "meta" [ attribute "name" "viewport", attribute "content" "width=device-width, initial-scale=1" ] []
            , node "meta" [ attribute "name" "description", attribute "content" "This is Michael Weiss's personal site." ] []
            , script "//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.1/highlight.min.js"
            , script "//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.1/languages/elm.min.js"
            , inlineScript "hljs.initHighlightingOnLoad();"
            , stylesheet "//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.1/styles/default.min.css"
            , stylesheet "//fonts.googleapis.com/css?family=Merriweather|Open+Sans|Proza+Libre|Inconsolata"
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "57x57", attribute "href" "/apple-icon-57x57.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "60x60", attribute "href" "/apple-icon-60x60.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "72x72", attribute "href" "/apple-icon-72x72.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "76x76", attribute "href" "/apple-icon-76x76.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "114x114", attribute "href" "/apple-icon-114x114.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "120x120", attribute "href" "/apple-icon-120x120.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "144x144", attribute "href" "/apple-icon-144x144.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "152x152", attribute "href" "/apple-icon-152x152.png" ] []
            , node "link" [ attribute "rel" "apple-touch-icon", attribute "sizes" "180x180", attribute "href" "/apple-icon-180x180.png" ] []
            , node "link" [ attribute "rel" "icon", attribute "type" "image/png", attribute "sizes" "192x192", attribute "href" "/android-icon-192x192.png" ] []
            , node "link" [ attribute "rel" "icon", attribute "type" "image/png", attribute "sizes" "32x32", attribute "href" "/favicon-32x32.png" ] []
            , node "link" [ attribute "rel" "icon", attribute "type" "image/png", attribute "sizes" "96x96", attribute "href" "/favicon-96x96.png" ] []
            , node "link" [ attribute "rel" "icon", attribute "type" "image/png", attribute "sizes" "16x16", attribute "href" "/favicon-16x16.png" ] []
            , node "link" [ attribute "rel" "manifest", attribute "href" "/manifest.json" ] []
            , node "meta" [ attribute "name" "msapplication-TileColor", attribute "content" "#ffffff" ] []
            , node "meta" [ attribute "name" "msapplication-TileImage", attribute "content" "/ms-icon-144x144.png" ] []
            , node "meta" [ attribute "name" "theme-color", attribute "content" "#ffffff" ] []
            ]
        , node "body" [] contentNodes
        ]


layout : Json.Decoder (Content content) -> (Content content -> Result String (List (Html Never))) -> Layout
layout decoder view =
    Browser.document
        { init = \contentJson -> ( contentJson, Cmd.none )
        , view =
            \contentJson ->
                case Json.decodeValue decoder contentJson of
                    Err error ->
                        { title = "error"
                        , body = [ Html.div [ attribute "error" <| Json.errorToString error ] [] ]
                        }

                    Ok content ->
                        case view content of
                            Err viewError ->
                                { title = "error"
                                , body = [ Html.div [ attribute "error" viewError ] [] ]
                                }

                            Ok viewHtml ->
                                { title = ""
                                , body = [ htmlTemplate content.siteTitle <| viewHtml ]
                                }
        , update = \msg contentJson -> ( contentJson, Cmd.none )
        , subscriptions = \_ -> Sub.none
        }
