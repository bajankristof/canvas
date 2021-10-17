FROM elixir:1.12-slim
EXPOSE 4000
WORKDIR /app
COPY ./* /app
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
CMD mix phx.server
