module Penny exposing (..)

{-

TODO: everything should be event-based

-}

-- IMPORTS ---------------------------------------------------------------------

import Html exposing (..)

import Date exposing ( Date )


-- PORTS -----------------------------------------------------------------------


-- HEPLERS ---------------------------------------------------------------------


-- ALIASES ---------------------------------------------------------------------


-- MODEL -----------------------------------------------------------------------

-- TODO: elixir should probably just maintain a websocket with the high-level stuff to show...

type alias Model
  = { events  : List Event
    , metrics : Metrics
    }

type alias Metrics
  = {
    }

type alias Event
  = { when : Date
    , what : What
    }

type What = Woke
          | Moved
          | Committed Project


-- INIT ------------------------------------------------------------------------

init : String -> ( Model, Cmd Msg )
init _
  = {} ! []


-- MSG -------------------------------------------------------------------------

type Msg = NoOp


-- UPDATE ----------------------------------------------------------------------

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model
  = case msg of

      _ ->

        model ! []


-- SUBS ------------------------------------------------------------------------

subs : Model -> Sub Msg
subs model = Sub.none


-- VIEW ------------------------------------------------------------------------

view : Model -> Html Msg
view model
  = main_ []
    [ context model
    ]


-- MAIN ------------------------------------------------------------------------

main : Program String Model Msg
main
  = Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subs
        }

