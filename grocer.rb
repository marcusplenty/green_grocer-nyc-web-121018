require 'pry'
def consolidate_cart(cart)
  new_hash = {}
  cart.each do |hash|
    hash.each do |item, hash1|
      x = hash[item][:price]
      y = hash[item][:clearance]
      if new_hash.has_key?(item)
        new_hash[item][:count] += 1
      else
        new_hash[item] = {:price => x, :clearance => y, :count => 1}
      end
    end
  end
  return new_hash
end

def apply_coupons(cart, coupons)
  if coupons == []
    return cart
  else
    coupons.each do |coupon|
      key = coupon[:item] # coupon item name
      if cart.has_key?(key) # doesnt break if a coupon doesnt apply 
        decrement = coupon[:num] #number of item require for the coupon to work
        old_count = cart[key][:count] # number of the particular item
        new_count = old_count-decrement
        new_key = key + " W/COUPON"
        new_price = coupon[:cost]
        if new_count >= 0 #if the coupon has the item
          cart[key][:count] = new_count
          if cart.has_key?(new_key)
            cart[new_key][:count] += 1
          else
            cart[new_key] ={:price => new_price, :clearance => cart[key][:clearance], :count => 1}
          end
        end
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, hash1|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  consoli=consolidate_cart(cart)
  apply_coupons(consoli,coupons)
  apply_clearance(consoli)
  sum = 0
  consoli.each do |item, hash1|
    sum += consoli[item][:price] * consoli[item][:count]
  end
  if sum >100
    sum = sum * 0.9
  end
  return sum
end
