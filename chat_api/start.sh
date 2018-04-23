echo "Sleeping for 5s"
sleep 5s
echo "Starting server"
mix deps.get && mix ecto.create && mix ecto.migrate && mix phx.server