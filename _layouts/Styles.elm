module Styles exposing (styles)

import Css exposing (..)
import Css.Global exposing (..)
import Css.Media as Media exposing (..)
import Html exposing (Html)
import Html.Styled


backgroundTheme : Color
backgroundTheme =
    hex "ffffff"


textPrimary : Color
textPrimary =
    rgba 0 0 0 0.87


headerBackground : Color
headerBackground =
    hex "fafafa"


footerBackground : Color
footerBackground =
    headerBackground


linkColor : Color
linkColor =
    hex "1976d2"


hoverLinkColor : Color
hoverLinkColor =
    hex "bbdefb"


visitedLinkColor : Color
visitedLinkColor =
    hex "1565c0"


activeLinkColor : Color
activeLinkColor =
    hex "2196f3"


styles : Html msg
styles =
    let
        wideScreen =
            withMedia [ only screen [ Media.minWidth <| Css.px 600 ] ]

        codeStyle =
            [ fontFamilies [ "Inconsolata", .value monospace ]
            ]
    in
    global
        [ body
            [ padding <| px 0
            , margin <| px 0
            , backgroundColor <| backgroundTheme
            , Css.color <| textPrimary
            , fontFamilies [ "Merriweather", "serif" ]
            , fontSize <| px 18
            , lineHeight <| Css.em 1.6
            ]
        , a
            [ Css.color linkColor
            ]
        , code codeStyle
        , Css.Global.pre
            [ descendants
                [ code [ important <| overflowX Css.scroll ] ]
            ]
        , each [ h1, h2, h3, h4, h5, h6 ]
            [ fontFamilies [ "Merriweather", "serif" ]
            , lineHeight <| Css.em 1.1
            ]
        , h1 [ fontSize <| Css.em 2.66667, marginBottom <| rem 2.0202 ]
        , h2 [ fontSize <| Css.em 2.0, marginBottom <| rem 1.61616 ]
        , h3 [ fontSize <| Css.em 1.33333, marginBottom <| rem 1.21212 ]
        , h4 [ fontSize <| Css.em 1.2, marginBottom <| rem 0.80808 ]
        , each [ h5, h6 ] [ fontSize <| Css.em 1.0, marginBottom <| rem 0.60606 ]
        , p [ margin3 auto auto (rem 1.5) ]
        , Css.Global.small [ fontSize <| pct 65 ]
        , class "header" [ backgroundColor headerBackground, descendants [ a [ Css.color <| textPrimary, textDecoration none ] ] ]
        , class "header-logo"
            [ textAlign center
            , wideScreen [ textAlign left ]
            , fontWeight (int 500)
            ]
        , class "navigation"
            [ textAlign center
            , padding <| px 10
            , marginTop <| px -20
            , fontWeight (int 300)
            , descendants
                [ ul
                    [ margin <| px 0
                    , padding <| px 0
                    , wideScreen [ lineHeight <| px 64 ]
                    ]
                , li
                    [ display inlineBlock
                    , marginRight <| px 20
                    ]
                ]
            , wideScreen [ marginTop <| px 0, padding <| px 0, textAlign right ]
            ]
        , class "content"
            [ Css.maxWidth <| vw 100
            ]
        , class "footer"
            [ textAlign center
            , backgroundColor <| footerBackground
            , Css.color <| hex "000000"
            , descendants
                [ a [ Css.color <| textPrimary, textDecoration none ]
                , svg [ paddingRight <| px 5, verticalAlign baseline ]
                ]
            , wideScreen
                [ lineHeight <| px 64
                , textAlign right
                , descendants
                    [ class "link"
                        [ display inlineBlock
                        , marginRight <| px 20
                        ]
                    ]
                ]
            ]
        , class "post-metadata"
            [ marginTop <| Css.em -0.5
            , marginBottom <| Css.em 2.0
            , descendants
                [ each [ a, span ]
                    [ display inlineBlock
                    , marginRight <| px 5
                    ]
                , a
                    [ borderRadius <| px 3
                    , backgroundColor <| backgroundTheme
                    , paddingLeft <| px 5
                    , paddingRight <| px 5
                    ]
                ]
            ]
        ]
        |> Html.Styled.toUnstyled
