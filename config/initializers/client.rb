# Set the global CollectionSpace Client constant

$collectionspace_client = CollectionSpace::Client.new(
  CollectionSpace::Configuration.new(
    base_uri: Rails.application.secrets[:collectionspace_base_uri],
    username: Rails.application.secrets[:collectionspace_username],
    password: Rails.application.secrets[:collectionspace_password],
    page_size: 50,
    include_deleted: false,
    throttle: 0.10,
    verify_ssl: false,
  )
)