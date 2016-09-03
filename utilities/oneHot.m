% clear l loc l_one_hot
% l=labels(1,:)';
% [~, loc] = ismember(l, unique(l));
% l_one_hot = ind2vec(loc')';

clear l loc l_one_hot
l=expectedSequence;
[~, loc] = ismember(l, unique(l));
l_one_hot = ind2vec(loc')';