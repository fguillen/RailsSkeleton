module MarkdownRenderer
  def self.markdown
    @@markdown ||=
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true,
        # escape_html: true,
        fenced_code_blocks: true,
        filter_html: true,
        hard_wrap: true,
        no_intra_emphasis: true,
        prettify: true,
        space_after_headers: true,
        tables: true,
        with_toc_data: true
      )
  end

  def self.render(text)
    markdown.render(text)
  end
end
