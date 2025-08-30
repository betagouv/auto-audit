# frozen_string_literal: true

require 'cucumber/rspec/doubles'

Sachantque("je suis {string} avec l'email {string}") do |name, email|
  @user = FactoryBot.create(
    :user,
    :with_active_mission,
    fullname: name,
    primary_email: email
  )
end

Given('je participe au produit {string}') do |name|
  startup = FactoryBot.create(:startup, name: name)

  @user.missions.last.startups << startup

  @user.reload
  @user.missions.reload
  @user.active_startups.reload
end

Quand('je me connecte') do
  hash = {
    provider: 'developer',
    info: {
      email: @user.primary_email
    }
  }

  OmniAuth.config.mock_auth[:developer] = OmniAuth::AuthHash.new(hash)

  steps %(
    Quand je me rends sur la page d'accueil
    Et que je clique sur "Évaluez vos services"
    Et que je clique sur "Se connecter"
  )
end

Quand('je complète le standard {string}') do |nom|
  steps %(
    Quand je clique sur "#{nom}"
    Et que je choisis "Oui" pour chaque critère
    Et que je clique sur "Enregistrer ma réponse"
  )
end

Quand('je retourne au sommaire de l\'évaluation en cours') do
  step("je clique sur 'Evaluation du produit'")
end

Quand("je choisis {string} pour chaque critère") do |choix|
  page
    .all('.question-section fieldset')
    .each do |fieldset|
    within(fieldset) { choose(choix) }
  end
end

Alors("la page contient {string} pour le standard {string}") do |state, name|
  within("ol.fr-task-list__items") do |ol|
    within("li", text: name) do |item|
      expect(item).to have_text(state)
    end
  end
end

FEATURE_FLAGS_MAP = {
  "question suivante" => :next_question
}

Quand("la fonctionnalité {string} est activée") do |feature|
  name = FEATURE_FLAGS_MAP[feature]

  allow_any_instance_of(FeatureHelper)
    .to receive(:has_enabled_feature?)
    .with(name).and_return true
end
