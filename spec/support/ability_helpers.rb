shared_examples_for 'read and update access granted' do
  it 'should allow read' do
    expect(ability).to be_able_to(:read, resource, token) if token
    expect(ability).to be_able_to(:read, resource) unless token
  end

  it 'should allow update' do
    expect(ability).to be_able_to(:update, resource, token) if token
    expect(ability).to be_able_to(:update, resource) unless token
  end
end
