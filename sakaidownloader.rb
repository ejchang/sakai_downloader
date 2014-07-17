require 'rubygems'
require 'mechanize'
require 'highline/import'

agent = Mechanize.new

page = agent.get('https://sakai.duke.edu/access/content/group/b2cf1904-9cd2-40d5-bba2-37a344e10691/')

sakai_form = page.form_with(action: "/idp/authn/external")

sakai_form.j_username = 'ejc24'

sakai_form.j_password = ask("Enter your password:  ") { |q| q.echo = false }

page = agent.submit(sakai_form, sakai_form.buttons.first)

submit_form = page.form_with(action:  "https://sakai.duke.edu/Shibboleth.sso/SAML2/POST")

page = agent.submit(submit_form, submit_form.buttons.first)

agent.pluggable_parser.pdf = Mechanize::Download

page.links.each do |link|
	agent.get(link).save() if link.href.end_with?("pdf")
end

