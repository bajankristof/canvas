ARG MIX_ENV=prod
FROM elixir:1.12-slim
EXPOSE 4000
COPY . /app
WORKDIR /app
ARG MIX_ENV
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
RUN mix phx.digest
RUN mix assets.deploy
CMD mix phx.server
