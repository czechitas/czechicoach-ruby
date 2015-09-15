module CoachesHelper
  def city_link(text, filter = text)
    disabled = params[:city_filter] == filter ? "disabled" : ""

    link_to text,
            coaches_path(city_filter: filter,
                         skill_filter: params[:skill_filter],
                         query: params[:query]),
            class: "btn btn-success #{disabled}"
  end

  def skill_link(text, filter = text)
    disabled = params[:skill_filter] == filter ? "disabled" : ""

    link_to text,
            coaches_path(skill_filter: filter,
                         city_filter: params[:city_filter],
                         query: params[:query]),
            class: "btn btn-info #{disabled}"
  end
end
