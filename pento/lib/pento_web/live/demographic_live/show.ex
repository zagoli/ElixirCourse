defmodule PentoWeb.DemographicLive.Show do
	use Phoenix.Component
	import Phoenix.HTML
	alias PentoWeb.ExpandMore
	alias Pento.Survey.Demographic

	attr :demographic, Demographic, required: true

	def details(assigns) do
		~H"""
		<div>
			<h2 class="font-medium text-2xl">
				Demographics <%= raw "&#x2713;" %>
			</h2>
			<ExpandMore.expand_more id="demographics">
					<h2>Gender: <%= @demographic.gender %></h2>
					<h2>Year of birth: <%= @demographic.year_of_birth %></h2>
					<h2>Education: <%= @demographic.education %></h2>
			</ExpandMore.expand_more>
		</div>
		"""
	end

end