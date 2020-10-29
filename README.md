## Models

### Website

- `belongs_to :user`
- `has_many :webpages`
- `has_many :dns_records`
- `title:string`
- `url:string`
    - Need to run a callback to ensure just the domain with subdomain is saved. Eg. app.example.com or www.example.com

### Webpage

- `belongs_to :website`
- `has_many: :screenshots`
- `has_many: :html_documents`
- `title:string`
- `path:string`
    - Need to run a callback that ensures the final result saved to the database is  `website.url + path`, and that the path is does not contain the `website.url`

### Screenshot

- `belongs_to :webpage`
- `has_one_attached :image`
- `width:integer`
- `height:integer`

### HTML Document

- `belongs_to :webpage`
- `source_code:text`

### Zone File

- `belongs_to :website`
- `has_many :records`

### DNS Record

- `belongs_to :zone_file`
- `content:text`
- `priority:integer`
- `type:integer`
    - CNAME
        - name
    - A
        - address
    - AAAA
        - address
    - MX
        - exchange
        - preference
    - NS
        - name
    - TXT 
        - strings