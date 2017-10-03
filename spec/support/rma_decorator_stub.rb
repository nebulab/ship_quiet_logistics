class RMADecoratorStub < SimpleDelegator
  def number
    'RA368041525'
  end

  def returned_items
    return_items
  end

  def reason_name
    reason.name
  end

end
