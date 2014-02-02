module ApplicationHelper
  def sponsors 
    [
      {
        logo: "sponsor_logos/janrain_logo.png",
        link: "http://www.janrain.com",
      },
    ]
  end

  def escape_attribute_name(string)
    string.gsub(/\W|_/, '-').downcase
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer:language)
    end
  end

  def markdown(text)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end
end
