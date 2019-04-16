require "rails_helper"

RSpec.describe Cart do
  before :each do
    @umerch = User.create(name: "Ondrea Chadburn",street_address: "6149 Pine View Alley",city: "Wichita Falls",state: "Texas",zip_code: "76301",email_address: "ochadburn0@washingtonpost.com",password:"EKLr4gmM44", enabled: true, role:1)

    @item = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.2e2,
            enabled: true)
    @item2 = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.3e2,
            enabled: true)
    @item3 = @umerch.items.create!(
            item_name: "W.L. Weller Special Reserve",
            description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
            image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
            inventory: 4,
            current_price: 0.25e2,
            enabled: true)

    @coup1 = @umerch.coupons.create(name: "First Coupon", discount: 5.0)
    @discount_item = @umerch.items.create!(
      item_name: "Discounted Item",
      description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
      image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
      inventory: 9,
      current_price: 0.25e2,
      enabled: true)


    @discount_item_2 = @umerch.items.create!(
      item_name: "Discounted Item 2",
      description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
      image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
      inventory: 4,
      current_price: 0.25e2,
      enabled: true)


    @umerch2 = User.create(name: "Sibbie Cromett",street_address: "0 Towne Avenue",city: "Birmingham",state: "Alabama",zip_code: "35211",email_address: "scromett3@github.io",password:"fEFJeHdT1K", enabled: true, role:1)
    @non_discount_item = @umerch2.items.create!(
      item_name: "Non Discounted Item",
      description: "A sweet nose with a presence of caramel. Tasting notes of honey, butterscotch, and a soft woodiness. It's smooth, delicate and calm. Features a smooth finish with a sweet honeysuckle flair.",
      image_url: "http://www.buffalotracedistillery.com/sites/default/files/Weller_CYPB_750ml_front_LoRes.png",
      inventory: 9,
      current_price: 0.25e2,
      enabled: true
    )

    @cart = Cart.new({
      "#{@item.id}" => 3,
      "#{@item2.id}" => 1,
      "#{@item3.id}" => 2
      })

    @cart2 = Cart.new({
      "#{@non_discount_item.id}" => 3,
      "#{@discount_item.id}" => 2,
      "#{@discount_item_2.id}" => 2
      })

  end

  describe ".total_count" do
    it "should add up all cart items" do

      expect(@cart.total_count).to eq(6)
    end
  end

  describe ".count_of" do
    it "should count a specific item in a cart" do
      expect(@cart.count_of(@item.id)).to eq(3)
    end
  end

  describe ".add_item" do
    it "should add item to my cart" do
      @cart.add_item(@item2.id)
      expect(@cart.count_of(@item2.id)).to eq(2)
    end
  end

  describe ".subtotal" do
    it "should calculate item quantity times price" do
      expect(@cart.subtotal(@item)).to eq(60.0)
    end
  end

  describe ".cart_total" do
    it "calculates total cart price" do
      expect(@cart.cart_total).to eq(140.0)
    end
  end

  describe ".discounted_items" do
    it "returns all discounted items for a cart" do
      expect(@cart2.discounted_items(@coup1)).to eq([@discount_item, @discount_item_2])
    end
  end

  describe ".discounted_subtotal" do
    it "returns subtotal if any items that are discounted" do
      expect(@cart2.discounted_subtotal(@discount_item, @coup1)).to eq(47.5)
    end
  end

  describe ".discounted_price" do
    it "returns discounted price for a specific item in cart" do
      expect(@cart2.discount_price(@discount_item, @coup1)).to eq(23.75)
    end
  end

  describe ".discounted_cart_dif" do
    it "returns difference between discounted cart and regular cart total" do
      expect(@cart2.discounted_cart_dif(@coup1)).to eq(5)
    end
  end

  describe ".discounted_cart_total" do
    it "returns discounted cart total" do
      expect(@cart2.discounted_cart_total(@coup1)).to eq(170)
    end
  end

  describe ".discounted?" do
    it "returns true if item in cart is discounted" do
      session = {}
      session[:coupon] = @coup1
      expect(@cart2.discounted?(session, @discount_item)).to eq(true)
      expect(@cart2.discounted?(session, @non_discount_item)).to eq(false)
    end
  end


end
