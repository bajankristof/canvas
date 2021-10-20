# Canvas

## Time spent

  * 3.5 hours on 2021-10-17 between 16:00 - 19:30
  * 4 hours on 2021-10-18 between 10:00 - 14:00
  * 3 hours on 2021-10-18 between 15:00 - 17:00
  * 0.25 hours on 2021-10-18 between 18:45 - 19:00
  * 0.5 hours on 2021-10-20 between 17:15 - 17:45
  * 3.5 hours on 2021-10-20/21 between 21:00 - 00:30

Approx. a total of *15 hours*.

## Starting the application

### With Docker Compose

With Docker Compose you can simply start the application by running the below
commands from a terminal.

```bash
docker compose build && docker compose up
```

### With Elixir installed locally

With Elixir installed locally you may start the application (dev mode) directly
by running the following commands from a terminal.

```bash
docker compose up -d postgres
mix deps.get
mix compile
mix ecto.setup
mix phx.server
```

(You may also need to run `mix local.hex` and `mix local.rebar`.)

## Up and running

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser for the read-only web app.

### API

If you started the web app, visit [`localhost:4000`](http://localhost:4000) from your browser for the API instructions (on each relevant page, there will be a `How to interact with the ... API` section that you can check out).

You can also import the [`Postman collection`](https://github.com/bajankristof/canvas/blob/main/Canvas.postman_collection.json) from the repository if you are using Postman.
Once imported, you should create a Postman environment for the project as some request scripts modify the active environment to set and unset the active document ID.

#### Creating documents

You can create a document by sending a `POST` request to `/api/documents` with the following body structure:

```json
{
  "document": {
    "width": 24,
    "height": 8
  }
}
```

  * `width` will set width of the document (number of characters)
  * `height` will set the height of the document (number of rows)

#### Drawing rectangles

You can draw a rectangle on a document by sending a `POST` request to `/api/graphics/:document_id/draw-rect` (where `:document_id` is the ID of an existing document) with the following body structure:

```json
{
  "x": 1,
  "y": 1,
  "width": 10,
  "height": 4,
  "outline": "@",
  "fill": "x"
}
```

  * `x` and `y` will set the upper left corner of the rectangle (coordinates – the top left corner of the document is [0,0])
  * `width` and `height` will set the size of the rectangle (as described at `Creating documents` above)
  * (optional) `outline` will set the outline character of the rectangle
  * (optional) `fill` will set the fill character of the rectangle

_Note: One of `outline` or `fill` has to be specified!_

#### Flood filling an area

You can flood fill an area inside a document by sending a `POST` request to `/api/graphics/:document_id/flood-fill` (where `:document_id` is the ID of an existing document) with the following body structure:

```json
{
  "x": 1,
  "y": 1,
  "fill": "x"
}
```

  * `x` and `y` will set the starting position of the flood fill operation (coordinates  – as described at `Drawing rectangles`)
  * `fill` will set the fill character of the operation
