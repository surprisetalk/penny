port module Penny exposing (..)

{-

TODO: everything should be insert-only events

-}

-- IMPORTS ---------------------------------------------------------------------

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

-- import Date exposing ( Date )

-- import Http

import Json.Decode as JD exposing ( Decoder )
import Json.Encode as JE

import Dict exposing ( Dict )

import String exposing ( toLower )


-- PORTS -----------------------------------------------------------------------

port mode : (JD.Value -> msg) -> Sub msg

port tasks : (JD.Value -> msg) -> Sub msg

port publish : JE.Value -> Cmd msg


-- HELPERS ---------------------------------------------------------------------

(=>) = (,)

(:=) = JD.field


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
  | Tidy
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
    { id    : Int
    , done  : Bool
    , name  : String
    , body  : String
    , kind  : Kind
    , tasks : List Task
    }

type Kind
  = Study
  | Project
  | Chore Bool   Bool
    --    urgent important

untask (Task_ t) = t

isStudy = untask >> .kind >> (==) Study

isProject = untask >> .kind >> (==) Project

isChore (Task_ {kind})
  = kind == Chore True  False
 || kind == Chore False True
 || kind == Chore True  True
 || kind == Chore False False

type alias Notification
  = {} -- TODO


-- INIT ------------------------------------------------------------------------

init : String -> ( Model, Cmd Msg )
init _
  = { mode  = Naught
    , tasks = []
    }
  ! []

-- MSG -------------------------------------------------------------------------

type Msg = NoOp
         | Undo             
         | ModeSkip
         | ModeUpdate Mode
         | TasksUpdate (List Task)
         | Push Notification -- TODO: push notification


-- UPDATE ----------------------------------------------------------------------

update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({mode,tasks} as model)
  = case msg of

      TasksUpdate tasks_ ->

        { model
          | tasks
            = Dict.values
            <| Dict.union
              (tasks_ |> List.map (\(Task_ task) -> (task.id, Task_ task)) |> Dict.fromList)
              (tasks  |> List.map (\(Task_ task) -> (task.id, Task_ task)) |> Dict.fromList)
        }
      ! []

      ModeUpdate mode ->

        { model | mode = mode } ! []

      ModeSkip ->

        model
        ! [ publish
            <| JE.object
              [ "topic" => JE.string "mode:skip"
              , "body"  => JE.null
              ]
          ]

      _ ->

        model ! []


-- SUBS ------------------------------------------------------------------------

subs : Model -> Sub Msg
subs model
  = Sub.batch
    [ mode  (decodeMode  >> Result.mapError (Debug.log  "mode decode") >> Result.withDefault model.mode  >>  ModeUpdate)
    , tasks (decodeTasks >> Result.mapError (Debug.log "tasks decode") >> Result.withDefault model.tasks >> TasksUpdate)
    ]


-- VIEW ------------------------------------------------------------------------

-- TODO: use timers to show long we've been doing a thing

viewTask : Task -> Html Msg
viewTask (Task_ {id,done,name,body})
  = li []
    [ flip input []
      [ type_ "checkbox"
      , checked done
      ]
    , label []
      [ text name
      ]
    , ul [ style [ "margin-top" => "0px" ] ]
      <| List.map (\s -> li [] [ text s ])
      <| String.split "\n"
      <| body
    ]

viewImportantTask : Task -> Html Msg
viewImportantTask (Task_ {id,done,name,body})
  = text "TODO"

viewTasks : List Task -> Html Msg
viewTasks tasks
  = let mostImportantTask
          = tasks
          |> List.take 1
          |> List.map viewImportantTask

        newTask
          = [ li []
              [ input []
                [
                ]
              ]
            ]

    in div []
     <| mostImportantTask
    ++ [ ul []
         <| List.map viewTask tasks
        ++ newTask
       ]

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


            Tidy ->

              -- TODO: 5:00 countdown
              -- TODO: prompts (with checkboxes if completed)
              -- TODO:   get rid of something!
              -- TODO:   etc

              text "be kind to your stuff!"
              

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

              div []
              [ text "make something amazing! and make it quick & messy"
              , viewTasks
                <| List.filter isProject
                <| tasks
              ] 
              

            Learn ->

              -- TODO: studies list & github stuff
              -- TODO: integrate spaced-repetition quizzes, etc
              -- TODO:   chinese
              -- TODO:   music theory
              -- TODO:     modes
              -- TODO:     "good" notes (on guitar and piano)
              -- TODO:     scale relations
              -- TODO:     ear training
              -- TODO:   chem
              -- TODO:     elements
              -- TODO:     "household" compounds (everyday things)
              -- TODO:     synthesis calculations
              -- TODO:     drugs
              -- TODO:   math (many branches)
              -- TODO:     equations
              -- TODO:     short exercices
              -- TODO:   poetry & quotes
              -- TODO:   physics
              -- TODO:   genetics
              -- TODO:     i don't even know what
              -- TODO:   cognitive "tools"
              -- TODO:     math
              -- TODO:     estimations
              -- TODO:       "how big?"
              -- TODO:       "how long?"
              -- TODO:       "how much energy?"
              -- TODO:       "how many?"
              -- TODO:       "how fast?"
              -- TODO:   biology
              -- TODO:     anatomy
              -- TODO:     nutrition
              -- TODO:     taxonomy
              -- TODO:   apl syntax hehe
              -- TODO:   geography
              -- TODO:     freeways!
              -- TODO:   electrical
              -- TODO:     circuit problems

              div []
              [ text "learn something!"
              , viewTasks
                <| List.filter isStudy
                <| tasks
              ] 

            Work ->

              -- TODO: chores
              -- TODO: sort by urgent/important matrix then oldest
              -- TODO:   "is this actionable?" -> "break it down"

              div []
              [ text "do your chores!"
              , viewTasks
                <| List.filter isChore
                <| tasks
              ] 
              

            Connect ->

              -- TODO: call list, letters list, smss, emails, make a craft for somebody

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
       [ h1 []
         [ mode |> toString |> String.toUpper |> text
         , span [ style [ "font-size" => "14pt" ] ]
           [ button [ onClick ModeSkip ] [ text "skip" ]
           ]
         ]
       , div []
         [ now
         ]
       , aside []
         [ stats
         -- , button [ onClick Undo ] [ text "undo" ]
         ]
       ]
          

-- JSON ------------------------------------------------------------------------

decodeMode : JD.Value -> Result String Mode
decodeMode = JD.decodeValue modeDecoder

modeDecoder : Decoder Mode
modeDecoder
  = JD.field "mode" JD.string
  |> JD.andThen
  ( \mode ->
      case toLower mode of
        "frolic"     -> JD.succeed Frolic     -- Prepare
        "naught"     -> JD.succeed Naught     
        "tidy"       -> JD.succeed Tidy
        "exercise"   -> JD.succeed Exercise   
        "fuel"       -> JD.succeed Fuel
        "groom"      -> JD.succeed Groom
        "inspire"    -> JD.succeed Inspire
        "strategize" -> JD.succeed Strategize 
        "create"     -> JD.succeed Create     -- Queue
        "learn"      -> JD.succeed Learn
        "work"       -> JD.succeed Work
        "connect"    -> JD.succeed Connect
        "consume"    -> JD.succeed Consume
        "review"     -> JD.succeed Review     -- Meta
        "automate"   -> JD.succeed Automate
        "journal"    -> JD.succeed Journal
        "read"       -> JD.succeed Read       -- Sleep
        "sleep"      -> JD.succeed Sleep
        _            -> JD.fail <| mode ++ " is not a valid mode"
  )   

decodeTasks = JD.decodeValue tasksDecoder

tasksDecoder : Decoder (List Task)
tasksDecoder
  = JD.field "tasks" 
  <| JD.list
  <| JD.map Task_
  <| JD.map5 (\id done name body kind -> { id = id, done = done, name = name, body = body, kind = kind, tasks = [] })
    ("id"   := JD.int   )
    (JD.succeed False)
    -- ("done" := JD.bool  )
    -- TODO: we gotta join the event log
    ("name" := JD.string)
    ("body" := JD.string)
    ( JD.field "kind" JD.string
    |> JD.andThen taskKindDecoder
    )

taskKindDecoder kind
  = case String.toLower kind of
      "project" -> JD.succeed Project
      "study"   -> JD.succeed Study
      "chore"   -> JD.map2 Chore
                  ("urgent"    := JD.bool) 
                  ("important" := JD.bool) 
      _         -> JD.fail <| "could not decode kind: '" ++ kind ++ "'"

-- MAIN ------------------------------------------------------------------------

main : Program String Model Msg
main
  = Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subs
        }

