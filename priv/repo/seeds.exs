# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Populus.Repo.insert!(%Populus.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Populus.Factory

IO.puts("Seeding Project Documents")

1..5
|> Enum.each(fn _i ->
  bs_text = Enum.map(1..400, fn _i -> Faker.Company.buzzword() end) |> Enum.join(" ")

  Factory.insert!(:project_doc, %{
    title: "Report on: #{Faker.Company.buzzword()}",
    text: bs_text
  })
end)
