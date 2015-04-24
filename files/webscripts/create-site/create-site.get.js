var activityLog = [];
function main() {
	siteService.createSite(args.preset, args.url, args.title, args.description, args.visibility);

	activityLog.push("Created site with preset '" + args.preset + "', site '" + args.url + "'");
	model.activityLog = activityLog;
}
main();
