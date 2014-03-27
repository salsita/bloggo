Bloggo (server)
===============

# What's that?
Bloggo is a [Poet](http://jsantell.github.io/poet/) based service that reads
your blog posts written in Markdown (or some other format, but md is default) with YAML (or some other format, but YAML is default) front-matter and serves them as HTML partials along with some metadata.

There's no database Bloggo. Everything is on disk (or in memory).

## Important Notes
The posts must have **unique titles**. Otherwise only one of the set of posts with
the same title will be displayed (or returned by the API).

## Disqus Integration
If you want to integrate Disqus with a blog post, please specify a unique `id`
property in the front-matter.

## Other front-matter properties
The posts must have a `title` and they should have an `author` and a `date`.

Example front-matter:

    ---
    title: "Bestest post"
    tags: ["blog", "test", "markdown"]
    category: "javascript"
    date: "2-2-2011"
    id: "disqus post id 123456"
    ---


## API
Send a GET to `/api/posts` to get a list of all the posts. Include `from`(where
to start) and `limit` (how many to fetch) query params for paging.

### Filtering

#### By date
Use `year` or (`year`, `month`) query params to only get posts for a particular year or year/month combo. If you only use `month`, it will still work but you'll get e.g. all the posts from all Januaries.

#### By category
Post can have a category (`category` string in front-matter). Get all the
posts for a category by GETting `/api/posts?category=foo`. You can only filter
a single category.

#### By tag
Same as category but, well use `tags` (`/api/posts?tags=[foo, bar]`). You can
filter for multiple tags - in that case you'll get only the posts that have all
the tags you requested (in set theory terms, it's a set difference).
