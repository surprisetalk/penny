module Penny exposing (..)

{-

TODO: everything should be insert-only events

-}

-- IMPORTS ---------------------------------------------------------------------

import Html exposing (..)
import Html.Events exposing (..)

-- import Date exposing ( Date )


-- PORTS -----------------------------------------------------------------------


-- HEPLERS ---------------------------------------------------------------------


-- ALIASES ---------------------------------------------------------------------


-- MODEL -----------------------------------------------------------------------

-- TODO: elixir should probably just maintain a websocket with the high-level stuff to show...

-- TODO: eventually, tasks/projects/reading-list/drills/etc should be converted to org-mode

type alias Model
  = { mode  : Mode
      -- TODO: an elixir cron should insert "new mode" events based on time and personal location
    , tasks : List Task
    }

type Mode
  = Frolic     -- Prepare
  | Naught     
  | Exercise   
  | Fuel
  | Groom
  | Inspire
  | Strategize 
  | Create     -- Queue
  | Learn
  | Work
  | Connect
  | Consume
  | Review     -- Meta
  | Automate
  | Journal
  | Read       -- Sleep
  | Sleep

type Task
  = Task_
    { done      : Bool
    , name      : String
    , body      : String
    , kind      : Kind
    , tasks     : List Task
    }

type Kind
  = Study
  | Project
  | Chore Bool   Bool
    --    urgent important

-- type alias Model
--   = { events  : List Event
--     , metrics : Metrics
--     }

-- type alias Metrics
--   = {
--     }

-- type alias Event
--   = { when : Date
--     , what : What
--     }

-- type What = Woke
--           | Moved
--           | Committed Project

type alias Notification
  = {}
    -- TODO


-- INIT ------------------------------------------------------------------------

init : String -> ( Model, Cmd Msg )
init _
  = { mode  = Naught
    , tasks = []
    } ! []


-- MSG -------------------------------------------------------------------------

type Msg = NoOp
         | Skip              
         | Undo             
         | Push Notification -- TODO: push notification


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
view {mode,tasks}
  = let now : Html Msg
        now = case mode of

            Frolic ->

              -- TODO: pick from "suggestions"
              -- TODO:   make some tea
              -- TODO:   splatter some paint
              -- TODO:   lick something
              -- TODO:   do a ceremony

              text "thank you universe!"
              

            Naught ->

              text "whatever"
              

            Exercise ->

              -- TODO: stats / logs
              -- TODO: make a really easy inc/dec to indicate what was done

              text "GET BIG"
              

            Fuel ->

              -- TODO: do we have 3 days of food? if not, add "food" shopping to list
              -- TODO: instacart or amazon fresh

              ul []
              [ li [] [ text "eat breakfast" ]
              , li [] [ text "prepare lunch" ]
              , li [] [ text "fetch water"   ]
              ]
              

            Groom ->

              -- TODO: countdown timer?
              -- TODO: "did you floss? did you brush?"

              div []
              [ ul []
                [ li [] [ text "floss" ]
                , li [] [ text "brush teeth" ]
                ]
              , text "your teeth are really important :0"
              ]


            Inspire ->

              -- TODO: pick from inspiration list

              text "inspire yourself!"
              

            Strategize ->

              -- TODO: overview
              -- TODO: arrange priority

              text "look over your list"
              

            Create ->

              -- TODO: show project stats in git
              -- TODO: make create tasks!
              -- TODO:   "is this actionable?" -> "break it down"

              text "make something amazing! and make it quick & messy"
              

            Learn ->

              -- TODO: integrate spaced-repetition quizzes, etc
              -- TODO: studies list & github stuff

              text "learn something"
              

            Work ->

              -- TODO: chores
              -- TODO: sort by urgent/important matrix then oldest
              -- TODO:   "is this actionable?" -> "break it down"

              text "do your chores"
              

            Connect ->

              -- TODO: call list, letters list, smss, emails

              text "remind somebody how much they mean to you!"
              

            Consume ->

              -- TODO: display stuff from pocket/etc inline
              -- TODO: timer

              text "loaf!"
              

            Review ->

              -- TODO: daily summaries
              -- TODO: all events that occurred since last review
              -- TODO:   edit/remove/insert ?
              -- TODO:   mark as bad/neutral/good to give "score"?

              text "what have you done lately?"


            Automate ->

              -- TODO: "what are some things that we can automate?"
              -- TODO:   add to tasks

              ul []
              [ li [] [ text "what 20% of today caused 80% of headaches?" ]
              , li [] [ text "what useless things did we do?" ]
              ]


            Journal ->

              -- TODO: open a journal prompt

              text "what made you feel today?"
              

            Read ->

              -- TODO: reading list
              -- TODO:   good reads?

              text "read something good!"
              

            Sleep ->

              -- TODO: sleep stats

              text "zzzzzzzz"

        stats : Html Msg
        stats
          = div [] []
            -- TODO

    in main_ []
       [ div []
         [ now
         ]
       , aside []
         [ stats
         , button [ onClick Skip ] [ text "skip" ]
         , button [ onClick Undo ] [ text "undo" ]
         ]
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

