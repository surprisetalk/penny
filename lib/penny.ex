defmodule Penny do

  # TODO: does it make sense to just make this the webserver? consolidate split the services?
  
  @moduledoc """
  TODO
  """

  @doc """
  TODO

  ## Examples

      iex> TODO
      TODO

  """
  def main(args) do
    tasks
  end

  # ah, use browser push notifications to ping

  # major use: "nudge" to do good behavior at specific times of the day
  #   too much time on reddit? tell me to "do nothing"! or watch a lecture!
  #   not working in a "work" location? push notification!
  #   on a device late at night? shut that down
  #   ask for how to proceed when crons (ie maria) get stuck
  #   track projects' progress, app-usage, sleep, location, etc
  #   

  # where should the "event log" be stored?

  # http://hostiledeveloper.com/2016/02/24/hey-watch-it-or-how-to-monitor-files-in-elixir.html
  # https://github.com/synrc/fs

  # rescuetime
  # http://blog.stephenwolfram.com/2012/03/the-personal-analytics-of-my-life/
  # https://www.quantifiedbob.com/
  # https://www.gwern.net/

  # defp parse_args(args) do
  #   {options, _, _} = OptionParser.parse(args,
  #     switches: [name: :string]
  #   )
  #   options
  # end

  # def process([]) do
  #   IO.puts "No arguments given"
  # end

  # def process(options) do
  #   IO.puts "Hello #{options[:name]}"
  # end

end
