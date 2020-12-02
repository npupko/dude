# TODO
response = client.get("/1/boards/#{BOARD_ID}/cards/#{id}")
extracted_branch_name = JSON.parse(response.body).dig('url').rpartition('/').last
Git::Checkout.new.call(extracted_branch_name)
