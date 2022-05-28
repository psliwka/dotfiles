cd $PREFIX
git fetch
git verify-commit FETCH_HEAD || {
	yesno "Remote signature verification failed. Proceed anyway?" && fix_signature=1
}
git rebase
if [[ "$fix_signature" -eq 1 ]]; then
	git commit --gpg-sign --allow-empty --message "Add valid signature on top of HEAD"
fi
git push
