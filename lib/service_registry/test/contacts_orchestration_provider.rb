module ServiceRegistry
  module Test
    class ContactsOrchestrationProvider < BaseOrchestrationProvider      
    	def request_contact_details_for_domain_perspective
    		process_result(@iut.contact_details_for_domain(@domain_perspective))
    	end

    	def no_contact_details_for_domain_perspective
    		contacts = @iut.contact_details_for_domain(@domain_perspective)['data']['contacts']
    		# contacts ||= {}
    		contacts.each do |contact|
    			@iut.remove_contact_from_domain(@domain_perspective, contact)
    		end
    	end

    	def one_contact_for_domain_perspective
    		no_contact_details_for_domain_perspective
    		@iut.add_contact_to_domain_perspective(@domain_perspective, @contact_1)
    	end

    	def multiple_contacts_for_domain_perspective
    		no_contact_details_for_domain_perspective
    		@iut.add_contact_to_domain_perspective(@domain_perspective, @contact_1)
    		@iut.add_contact_to_domain_perspective(@domain_perspective, @contact_2)
    	end

    	def has_received_empty_list_of_contacts?
    		data['contacts'] == []
    	end

    	def has_received_list_with_one_contact?
    		contacts = @iut.contact_details_for_domain(@domain_perspective)['data']['contacts']
    		(contacts.size == 1) and (contacts[0]['name'] == @contact_1['name']) and (contacts[0]['email'] == @contact_1['email']) and (contacts[0]['phone'] == @contact_1['phone']) and (contacts[0]['description'] == @contact_1['description'])
    	end

    	def has_received_list_with_all_contacts?
    		contacts = @iut.contact_details_for_domain(@domain_perspective)['data']['contacts']
    		(contacts.size == 2) and (contacts[0] == @contact_1) and (contacts[1] == @contact_2)
    	end

      def add_contact_to_domain_perspective
        process_result(@iut.add_contact_to_domain_perspective(@domain_perspective, @contact))
      end

      def contact_associated_with_domain_perspective?
        result = @iut.contact_details_for_domain(@domain_perspective)  
        result['data']['contacts'].include?(@contact)
      end

      def remove_contact_from_domain_perspective
        process_result(@iut.remove_contact_from_domain_perspective(@domain_perspective, @contact))
      end
    end
  end
end