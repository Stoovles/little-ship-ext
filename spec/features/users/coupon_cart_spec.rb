require 'rails_helper'

RSpec.describe "Apply Coupon to Cart", type: :feature do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)
    @u1 = User.create(name: "Con Chilver",street_address: "16455 Miller Circle",city: "Van Nuys",state: "California",zip_code: "91406",email_address: "cchilver2@mysql.com",password:"IrGmrINsmr9e", enabled: true, role:0)
    @umerch2 =User.create(name: "Rodrique Agott",street_address: "58972 Superior Drive",city: "Miami",state: "Florida",zip_code: "33125",email_address: "ragott4@over-blog.com",password:"llZIK9tlHoFz", enabled: true, role:1)

    @i1 = @umerch.items.create(item_name: "W.L. Weller Special Reserve",image_url: "http://www.buffalotracedistillery.com/sites/default/files/weller%20special%20reserve%20brand%20page%5B1%5D.png",current_price: 20.0,inventory: 4, description:"A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",enabled: true)

    @i2 = @umerch.items.create(item_name: "W.L. Weller C.Y.P.B.",image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",current_price: 35.0,inventory: 30, description:"A light aroma with citrus and oak on the nose. The palate is well rounded and balanced, with a medium-long finish and hints of vanilla.",enabled: false)
    @coup1 = @umerch.coupons.create(name: "First Coupon", discount: 5.0)
    @coup2 = @umerch.coupons.create(name: "Second Coupon", discount: 10.0)
    @coup3 = @umerch.coupons.create(name: "Third Coupon", discount: 15.0)
    @coup4 = @umerch.coupons.create(name: "Fourth Coupon", discount: 20.0)
    @coup5 = @umerch2.coupons.create(name: "Fifth Coupon", discount: 5.0)


  end

  describe "As a visitor or regular user" do
    it "only sees coupons from merchants who sell items in their cart" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u1)

      visit item_path(@i1)
      click_button "Add to Cart"

      visit cart_path

      select "Second Coupon", from: :coupon
      select "Third Coupon", from: :coupon
      select "Fourth Coupon", from: :coupon
      select "First Coupon", from: :coupon
      expect(page).to_not have_select(:coupon, selected: 'Fifth Coupon')

      click_on "Update Coupon"

      expect(page).to have_content("19")
    end

    it "does not show disabled coupons" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u1)
      coup6 = @umerch.coupons.create(name: "Disabled Coupon", discount: 10.0, enabled: false)
      visit item_path(@i1)
      click_button "Add to Cart"

      visit cart_path

      expect(page).to_not have_select(:coupon, selected: 'Disabled Coupon')
    end


    it "creates proper order object when checkout with coupon" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@u1)

      visit item_path(@i1)
      click_button "Add to Cart"

      visit cart_path


      select "Second Coupon", from: :coupon

      click_on "Update Coupon"

      expect(page).to have_content("Coupon has been applied")

      click_button "Check Out"

      @coup2.reload
      expect(@coup2.used).to eq(true)

      order = @u1.orders.first
      expect(order.coupon_id).to_not eq(nil)
    end
  end

end
