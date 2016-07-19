class RMADecoratorStub < SimpleDelegator
  def returned_items
    return_items
  end

  def reason_name
    reason.name
  end

end