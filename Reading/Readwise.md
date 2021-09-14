# Readwise

To review highlights from Books and Articles I use [Readwise](https://readwise.io/) everyday.

Readwise gives you up to 15 imported highlights every day to review.

Highlights can be imported via Kindle, Instapaper and many more.

```plantuml
!theme amiga

rectangle Instapaper
rectangle Kindle
rectangle PDFs
agent Readwise
actor User

Instapaper -> Readwise
Kindle -> Readwise
PDFs -> Readwise

User -left-> Readwise: reviews highlights
```

## Links
- [How I Remember Everything I Read](https://www.youtube.com/watch?v=AjoxkxM_I5g)